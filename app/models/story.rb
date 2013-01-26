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
# * *created_at*     : 作成日時
# * *updated_at*     : 更新日時
#
class Story < ActiveRecord::Base
  attr_accessible :id, :director_id, :episode, :title, :description, :deadline, :created_at, :updated_at
  has_many :cut
  belongs_to :director, :foreign_key => 'director_id', :class_name => 'user'
  belongs_to :anime, :foreign_key => 'anime_id'
end
