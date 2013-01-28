# -*- coding: utf-8 -*-

# = カットパートモデル
# Author:: Dolphin
# Date:: 2013.01.29
# 
class CutPart < ActiveRecord::Base
  attr_accessible :id, :name
  has_many :cut
end
