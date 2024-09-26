<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;

class PostController extends Controller
{
    public function getAllPosts()
    {
        return response([
            'posts'=> Post::orderBy('created_at','desc')->with('user:id,name,profile_picture')->withCount('comments','likes')
            ->with('likes',function($like){
                return $like->where('user_id',auth()->user()->id)->select('id','user_id','post_id')->get();
            })->get()
        ],200);
    }
 
    public function showSinglePost(){
        return response([
            'post'=> Post::where('id',$id)->withCount('comments','likes')->get()
        ],200);
    }

    public function createPost(Request $request){
        $attrs = $request->validate([
            'tag'=>'required|string'
        ]);

        if ($request->hasFile('video')) {
            $filename = uniqid() .'.'. $request->file('video')->extension();
            $request->file('video')->storeAs('public/posts', $filename);
            $attrs = $request->all();
            $attrs['video'] = $filename;
    
            $post = Post::create([
                'tag'=>$attrs['tag'],
                'video'=>$attrs['video'],
                "user_id"=>auth()->user()->id
            ]);
    
        }
        // if ($request->hasFile('image')) {
        //     $filename = uniqid() .'.'. $request->file('image')->extension();
        //     $request->file('image')->storeAs('public/images', $filename); // Update the storage path to 'public/images'
        //     $incommingFields = $request->all();
        //     $incommingFields['image'] = $filename;
        
        //     Player::create($incommingFields);
        
        //     return redirect('/signup')->with('success', 'Player registered successfully');
        // }

        return response([
            'message'=>'Post created.',
            'post'=> $post
        ],200);
    }

    public function updatePost(Request $request,$id){
        $post = Post::find($id);

        if(!$post){
            return response([
                'message'=> 'Post not found'
            ], 403);
        }

        if(!$post->user_id!=auth()->user()->id){
            return response([
                'message'=> 'Permission denied.'
            ], 403);
        }

        $attrs = $request->validate([
            'tag'=>'required|string'
        ]);

        $post->update([
            'tag'=>'required|string'
        ]);
        
        return response([
            'message'=>'Post updated.',
            'post'=> $post
        ],200);
    }

    public function destroy($id)
    {
        $post = Post::find($id);

        if(!$post){
            return response([
                'message'=> 'Post not found'
            ], 403);
        }

        if(!$post->user_id!=auth()->user()->id){
            return response([
                'message'=> 'Permission denied.'
            ], 403);
        }

        $post->comments()->delete();
        $post->likes()->delete();
        $post->delete();

        return response([
            'message'=>'Post deleted.'
        ],200);
    }
    
}
