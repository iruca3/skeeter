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
      CutPart.create( :name => part.name, :episode_id => episode.id, :sort => part.sort )
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

  # カットパートを追加する。
  #
  # === 引数
  # [episode_id] エピソードID
  # [name] カットパートの名前
  # 
  # === 返り値
  # [CutPart] 追加したカットパートオブジェクト
  # 
  public
  def self.add( episode_id, name )
    # 既に同名のパートがないか確認
    return nil if CutPart.find( :all, :conditions => { :episode_id => episode_id, :name => name } ).count > 0

    # オーダーを計算
    order = CutPart.find( :all, :conditions => { :episode_id => episode_id } ).count
    order = order + 1
    
    return CutPart.create(
      :name => name,
      :episode_id => episode_id,
      :sort => order
    )

  end

  # カットパートを削除する。
  # 削除時に、ソート値をつけ直す。
  public
  def remove
    self.destroy
    cut_parts = CutPart.find( :all, :conditions => { :episode_id => self.episode_id }, :order => 'sort asc' )
    i = 1

    cut_parts.each do |cut_part|
      cut_part.sort = i
      cut_part.save
      i += 1
      
    end

  end

end
