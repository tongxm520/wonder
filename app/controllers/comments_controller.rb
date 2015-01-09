# encoding: utf-8
class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params[:comment])
    @comment.save
    @comments = Comment.where("post_id='#{params[:comment][:post_id]}'").order("created_at desc")
    
		 respond_to do |format|
		   format.js
		 end 
  end
end


