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
  
  # カット番号からカットを探す。
  #
  # === 引数
  # [episode] Episodeオブジェクト
  # [number] カット番号
  #
  # === 返り値
  # [Cut] Cutオブジェクト
  # [nil] 指定されたカット番号のカットが見つからなかった場合
  #
  def self.find_by_number( episode, number )
    ret = self.find(
      :first,
      :conditions => {
        :episode_id => episode.id,
        :number => number
      }
    )

    return ret

  end

end
