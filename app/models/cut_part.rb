# -*- coding: utf-8 -*-

# = カットパートモデル
# Author:: Dolphin
# Date:: 2013.01.29
# 
class CutPart < ActiveRecord::Base
  attr_accessible :id, :name, :episode_id, :sort
  belongs_to :episode, :foreign_key => 'episode_id'
  has_many :cut

  # プリセットのパートを登録
  #
  # === 引数
  # [episode] プリセットを登録するエピソードのオブジェクト
  #
  public
  def self.set_preset( episode )
    cut_parts = self.find(
      :all,
      :conditions => {
        :episode_id => nil
      }
    )

    cut_parts.each do |part|
      CutPart.create( :name => part.name, :episode_id => episode.id, :sort => part.order )
    end
    
  end

  # エピソードのカットパートを取得する。
  #
  # === 引数
  # [episode] Episodeオブジェクト
  #
  # === 返り値
  # [Array(CutPart)] カットパートオブジェクトの配列
  # 
  public
  def self.find_by_episode( episode )
    return self.find(
      :all,
      :conditions => {
        :episode_id => episode.id
      },
      :order => 'sort asc'
    )

  end

end
