# encoding: utf-8
class Reply < ActiveRecord::Base
  belongs_to :comment
end
