# encoding: utf-8
class RepliesController < ApplicationController
  def create
    params[:reply][:comment_id] = params[:comment_id]
    @reply = Reply.new(params[:reply])
    @reply.save
    @comment = Comment.find(params[:comment_id])
    @replies = Reply.where("comment_id='#{params[:comment_id]}'").order("created_at desc")
    
		 respond_to do |format|
		   format.js
		 end 
  end
end


