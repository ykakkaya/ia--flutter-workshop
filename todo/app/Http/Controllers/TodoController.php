<?php

namespace App\Http\Controllers;

use App\Models\Todo;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Validation\Rule;

class TodoController extends Controller
{
    public function index(Request $request)
    {
        $todos = $request->user()->todos();

        match ($request->query('status')) {
            'in_progress' => $todos->where('completed', false),
            'completed' => $todos->where('completed', true),
            default => null,
        };

        return $todos->latest('id')->get();
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate($this->rules(required: true));

        return response()->json($request->user()->todos()->create($data)->fresh(), 201);
    }

    public function show(Request $request, int $todo)
    {
        return $this->own($request, $todo);
    }

    public function update(Request $request, int $todo)
    {
        $item = $this->own($request, $todo);
        $item->update($request->validate($this->rules(required: false)));

        return $item;
    }

    public function destroy(Request $request, int $todo): Response
    {
        $this->own($request, $todo)->delete();

        return response()->noContent();
    }

    private function rules(bool $required): array
    {
        $sometimes = $required ? [] : ['sometimes'];

        return [
            'title' => [...$sometimes, 'required', 'string', 'max:255'],
            'description' => ['nullable', 'string', 'max:5000'],
            'priority' => ['sometimes', 'required', Rule::in(Todo::PRIORITIES)],
            'starts_at' => ['nullable', 'date'],
            'completed' => ['sometimes', 'boolean'],
        ];
    }

    /** Only resolves todos belonging to the authenticated user; others 404. */
    private function own(Request $request, int $id): Todo
    {
        return $request->user()->todos()->findOrFail($id);
    }
}
