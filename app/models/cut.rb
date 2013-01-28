# -*- coding: utf-8 -*-

# = カットモデル
# Author:: Dolphin
# Date:: 2013.01.29
# 
class Cut < ActiveRecord::Base
  attr_accessible :episode_id, :number, :cut_part_id, :picture, :memo
  belongs_to :part, :foreign_key => 'cut_part_id', :class_name => 'CutPart'
  belongs_to :episode, :foreign_key => 'episode_id'
  # has_many :work
  

end
