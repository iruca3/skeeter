# -*- coding: utf-8 -*-

require 'digest/md5'   # Digest::MD5
require 'digest/sha1'  # Digest::SHA1
require 'digest/sha2'  # Digest::SHA256

# = 暗号ヘルパー
# Author:: Dolphin
# Date:: 2013.01.26
#
# 暗号に関する処理を担うヘルパー
#
module CryptHelper

  # MD5 ハッシュ値の計算
  #
  # === 引数
  # [str] 文字列
  #
  # === 返り値
  # [string] MD5ハッシュ値
  #
  def CryptHelper.make_md5( str )
    return Digest::MD5.new.update( str ).to_s
  end

  # SHA1 ハッシュ値の計算
  #
  # === 引数
  # [str] 文字列
  #
  # === 返り値
  # [string] SHA1ハッシュ値
  #
  def CryptHelper.make_sha1( str )
    return Digest::SHA1.new.update( str ).to_s
  end

  # SHA256 ハッシュ値の計算
  #
  # === 引数
  # [str] 文字列
  #
  # === 返り値
  # [string] SHA256ハッシュ値
  #
  def CryptHelper.make_sha256( str )
    return Digest::SHA256.new.update( str ).to_s
  end

end
