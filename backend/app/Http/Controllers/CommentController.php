<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Models\Comment;
use Illuminate\Http\Request;

class CommentController extends Controller
{
    public function getAllComments($id){
        $post = Post::find($id);
        if(!$post){
            return response([
                'message'=>'Post not found.'
            ],403);
        }
        return response([
            'comment'=> $post->comments()->with('user:id,name,profile_picture')->get()
        ],200);
    }

    public function createComment(Request $request,$id){
        $post = Post::find($id);
        if(!$post){
            return response([
                'message'=>'Post not found.'
            ],403);
        }

        $attrs = $request->validate([
            'comment'=>'required|string'
        ]);

        Comment::create([
            'comment'=>$attrs['comment'],
            'post_id'=>$id,
            'user_id'=>auth()->user()->id
        ]);

        return response([
            'message'=> 'Comment created.'
        ],200);
    }

    public function update(Request $request)
    {
        $comment = Comment::find($id);

        if(!$comment){
            return response([
                'message'=>'Comment not found.'
            ],403);
        }

        if(!$comment->user_id!=auth()->user()->id){
            return response([
                'message'=> 'Permission denied.'
            ], 403);
        }

        $attrs = $request->validate([
            'comment'=>'required|string'
        ]);

        $comment ->update([
            'comment'=>$attrs['comment']
        ]);

        return response([
            'message'=> 'Comment updated.'
        ],200);
    }

    public function destroy($id)
    {
        $comment = Comment::find($id);

        if(!$comment){
            return response([
                'message'=>'Comment not found.'
            ],403);
        }

        if(!$comment->user_id!=auth()->user()->id){
            return response([
                'message'=> 'Permission denied.'
            ], 403);
        }

        $comment->delete();

        return response([
            'message'=> 'Comment deleted.'
        ],200);
    }
}
