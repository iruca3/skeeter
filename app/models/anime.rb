# -*- coding: utf-8 -*-

# = アニメモデル
# Author:: Dolphin
# Date:: 2013.01.27
#
# == フィールド
# * *id*                    : 通し番号
# * *title*                 : タイトル
# * *owner_id*              : 責任者のユーザID
# * *total_episode_number*  : 総エピソード数
# * *description*           : 説明
# * *status*                : 状態(STATUS_***)
# * *created_at*            : 作成日時
# * *updated_at*            : 更新日時
#
class Anime < ActiveRecord::Base
  after_initialize :default_values
  attr_accessible :id, :title, :owner_id, :description, :created_at, :updated_at
  has_many :episode, :order => 'episode_number asc, created_at asc'
  belongs_to :owner, { :foreign_key => 'owner_id', :class_name => 'User' }

  # アニメの状態 凍結
  STATUS_FROZEN = 0

  # アニメの状態 進行中
  STATUS_ENABLED = 1

  # アニメの状態 終了済
  STATUS_FINISHED = 2

  # 初期データ
  private
  def default_values
    self.description = '' if self.description == nil
  end

  # アニメ状態のハッシュ配列を返す。
  #
  # === 返り値
  # [Hash] { 名称 => 値 } の形で、アニメ状態一覧を返す。
  #
  def self.statuses
    return {
      '進行中'  => STATUS_ENABLED,
      '終了済'  => STATUS_FINISHED,
      '凍結中'  => STATUS_FROZEN
    }

  end

  # エピソードの状態を調べて返す。
  # 
  # === 返り値
  # [string] 状態
  #
  public
  def episode_status
    # 準備中のものが1個でもあれば、準備中と返す。
    finish_count = 0
    progress_count = 0
    self.episode.each do |ep|
      if ep.status == Episode::STATUS_WAITING || ep.status == nil
        return '準備中'
      elsif ep.status == Episode::STATUS_PROGRESS
        progress_count += 1
      elsif ep.status == Episode::STATUS_FINISHED
        finish_count += 1
      end
    end

    self.total_episode_number = 0 if self.total_episode_number == nil
    return '進行中' if progress_count > 0
    return '終了済' if finish_count >= self.total_episode_number
    return '進行中'
  end

end
