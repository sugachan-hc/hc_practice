# frozen_string_literal: true

# 標準入力を1行ごとの配列として取得
if $stdin.tty?
  puts 'No input file specified.'
  exit
else
  input_lines = $stdin.readlines
end

# 配列要素を整形する関数
def format_array(input_line)
  input_line.chomp.split(',').map(&:to_i)
end

# 不正な値が含まれていた時のメッセージを表示する関数
def display_error_message(invalid_scores, error_message, line_message)
  return if invalid_scores.empty?

  puts "Check the #{line_message} of the input file."
  puts "It contains invalid value(s): #{invalid_scores}. #{error_message}"
  exit
end

# ホールの規定打数に不正な値がないかを検証する関数
def validate_standard_scores(standard_scores)
  invalid_scores = standard_scores.reject { |score| [3, 4, 5].include?(score) }
  display_error_message(invalid_scores, 'The value must be either 3, 4, or 5.', 'first line')
end

# プレイヤーの打数に不正な値がないかを検証する関数
def validate_player_scores(player_scores)
  invalid_scores = player_scores.reject { |score| score >= 1 }
  display_error_message(invalid_scores, 'The value must be greater than or equal to 1.', 'second line')
end

# 各ホールのゴルフスコアを出力する関数
def my_achievement(diff_score, player_score)
  case diff_score
  when 2..Float::INFINITY then "#{diff_score}ボギー"
  when 1 then 'ボギー'
  when 0 then 'パー'
  when -1 then 'バーディ'
  when -2 then player_score == 1 ? 'ホールインワン' : 'イーグル'
  when -3 then player_score == 1 ? 'ホールインワン' : 'アルバトロス'
  when -4 then 'コンドル'
  end
end

# 打数
standard_scores = format_array(input_lines[0]) # 規定打数
player_scores = format_array(input_lines[1]) # プレイヤーの打数

# 入力される値に不正な値がないかチェック(optional)
validate_standard_scores(standard_scores)
validate_player_scores(player_scores)

# 規定打数とプレイヤーの打数からゴルフスコアを出力
my_achievements = []
player_scores.each_with_index do |player_score, index|
  diff_score = player_score - standard_scores[index]
  my_achievements << my_achievement(diff_score, player_score)
end

puts my_achievements.join(',')
