# frozen_string_literal: true

require 'date'
require 'optparse'

# 年・月の取得
year = Date.today.year
month = Date.today.month

# -m オプションの解析
options = {}
opt = OptionParser.new
opt.on('-m month') { |m| options[:month] = m }
opt.parse!(ARGV)

# オプションなしの場合は当月とする
target_month = options[:month] || month.to_s

# 不正な月が入力された場合処理を中断
valid_months = (1..12).to_a.map(&:to_s)
unless valid_months.include?(target_month)
  puts "#{target_month} is neither a month number (1..12) nor a name"
  exit
end

# 見出し部分
target_month = target_month.to_i
week_title = %w[月 火 水 木 金 土 日] # 月曜始まり(仕様)
puts "      #{target_month}月 #{year}"
puts week_title.join(' ')

# 指定月の日数
last_day = Date.new(year, target_month, -1).day
days = (1..last_day).to_a

# 初日の表示位置から月初の空白日の日数を取得
wday = Date.new(year, target_month, 1).wday
first_day_position = wday.zero? ? 6 : wday - 1 # 月曜始まり位置調整
blank_days = Array.new(first_day_position, ' ')

# 空白日含む日数を格納した配列を7日毎に分割
output_days = blank_days + days
weeks = output_days.each_slice(7).to_a

# 各週の要素の桁を揃えて出力
weeks.each do |week|
  week.map! do |day|
    day.to_s.rjust(2, ' ')
  end
  puts week.join(' ')
end

