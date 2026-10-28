<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;

#[Fillable(['title', 'description', 'priority', 'starts_at', 'completed'])]
class Todo extends Model
{
    public const PRIORITIES = ['low', 'normal', 'high'];

    protected $attributes = ['priority' => 'normal'];

    protected function casts(): array
    {
        return [
            'completed' => 'boolean',
            'starts_at' => 'datetime',
        ];
    }
}
