<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\LikeController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\CommentController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

//public routes
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

//protected routes
Route::group(['middleware' => ['auth:sanctum']], function(){
    //user
    Route::get('/user', [AuthController::class, 'user']);
    Route::put('/user', [AuthController::class, 'update']);
    Route::post('/logout', [AuthController::class, 'register']);
    //post
    Route::get('/posts', [PostController::class, 'getAllPosts']);
    Route::post('/posts', [PostController::class, 'createPost']);
    Route::get('/posts/{id}', [PostController::class, 'showSinglePost']);
    Route::put('/posts/{id}', [PostController::class, 'updatePost']);
    Route::delete('/posts/{id}', [PostController::class, 'destroy']);
    //comment
    Route::get('/posts/{id}/comments', [CommentController::class, 'getAllComments']);
    Route::post('/posts/{id}/comments', [CommentController::class, 'createComment']);
    Route::put('/comments/{id}', [CommentController::class, 'update']);
    Route::delete('/posts/{id}', [CommentController::class, 'destroy']);
    //like
    Route::post('/posts/{id}/likes', [LikeController::class, 'likeorunlicke']);
});