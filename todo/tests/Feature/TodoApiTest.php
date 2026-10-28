<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class TodoApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_register_and_login(): void
    {
        $this->postJson('/api/register', [
            'name' => 'A', 'email' => 'a@x.com', 'password' => 'password1', 'password_confirmation' => 'password1',
        ])->assertCreated()->assertJsonStructure(['token', 'user']);

        $this->postJson('/api/login', ['email' => 'a@x.com', 'password' => 'password1'])
            ->assertOk()->assertJsonStructure(['token']);
        $this->postJson('/api/login', ['email' => 'a@x.com', 'password' => 'wrong'])->assertStatus(422);
    }

    public function test_requires_authentication(): void
    {
        $this->getJson('/api/todos')->assertUnauthorized();
    }

    public function test_users_only_see_their_own_todos(): void
    {
        $a = User::factory()->create();
        $b = User::factory()->create();

        Sanctum::actingAs($a);
        $id = $this->postJson('/api/todos', ['title' => 'mine'])->assertCreated()->json('id');

        Sanctum::actingAs($b);
        $this->getJson('/api/todos')->assertOk()->assertJsonCount(0);
        $this->patchJson("/api/todos/$id", ['completed' => true])->assertNotFound();
        $this->deleteJson("/api/todos/$id")->assertNotFound();

        Sanctum::actingAs($a);
        $this->patchJson("/api/todos/$id", ['completed' => true])->assertOk()->assertJson(['completed' => true]);
        $this->deleteJson("/api/todos/$id")->assertNoContent();
    }

    public function test_details_and_status_filter(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->postJson('/api/todos', ['title' => 'a'])->assertCreated()->assertJson(['priority' => 'normal', 'description' => null]);
        $id = $this->postJson('/api/todos', [
            'title' => 'b', 'description' => 'detay', 'priority' => 'high', 'starts_at' => '2026-11-01T09:30:00.000Z',
        ])->assertCreated()->assertJson(['priority' => 'high', 'description' => 'detay'])->json('id');

        $this->patchJson("/api/todos/$id", ['completed' => true])->assertOk();

        $this->getJson('/api/todos')->assertJsonCount(2);
        $this->getJson('/api/todos?status=in_progress')->assertJsonCount(1)->assertJsonPath('0.title', 'a');
        $this->getJson('/api/todos?status=completed')->assertJsonCount(1)->assertJsonPath('0.title', 'b');

        $this->postJson('/api/todos', ['title' => 'c', 'priority' => 'urgent'])->assertStatus(422);
        $this->postJson('/api/todos', ['title' => 'c', 'starts_at' => 'not-a-date'])->assertStatus(422);
    }
}
