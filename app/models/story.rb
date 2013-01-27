# -*- coding: utf-8 -*-

# = ストーリーモデル
# Author:: Dolphin
# Date:: 2013.01.27
#
# アニメの各話のモデル。
#
# == フィールド
# * *id*             : 通し番号
# * *anime_id*       : アニメID
# * *director_id*    : 監督のユーザID
# * *episode*        : 何話目か
# * *title*          : タイトル
# * *description*    : 説明
# * *deadline*       : 締切
# * *status*         : 状態
# * *created_at*     : 作成日時
# * *updated_at*     : 更新日時
#
class Story < ActiveRecord::Base
  after_initialize :default_values
  attr_accessible :id, :anime_id, :director_id, :episode, :title, :description, :deadline, :created_at, :updated_at
  has_many :cut
  belongs_to :director, :foreign_key => 'director_id', :class_name => 'user'
  belongs_to :anime, :foreign_key => 'anime_id'

  # 状態 準備中
  STATUS_WAITING = 0

  # 状態 進行中
  STATUS_PROGRESS = 1

  # 状態 終了済
  STATUS_FINISHED = 2

  # 状態 中止
  STATUS_ABORTED = 3

  # ストーリーの状態のハッシュ配列を返す。
  #
  # === 返り値
  # [Hash] { 名称 => 値 } の形で、ストーリー状態一覧を返す。
  #
  def self.statuses
    return {
      '準備中'  => STATUS_WAITING,
      '進行中'  => STATUS_PROGRESS,
      '終了済'  => STATUS_FINISHED,
      '中止'    => STATUS_ABORTED
    }

  end

  # 初期データをセット
  private
  def default_values
    self.title = '' if self.title == nil
    self.description = '' if self.description == nil
    
  end

  # ストーリーを作成する。
  #
  # == 引数
  # [anime] アニメオブジェクト
  # [story_name] ストーリー名
  #
  public
  def self.add( anime, story_name )
    new_story = self.create(
      :anime_id => anime.id,
      :director_id => nil,
      :episode => nil,
      :title => story_name,
      :description => '',
      :status => STATUS_WAITING,
      :deadline => nil
    )

    return nil if new_story.new_record?
    return new_story

  end

end
