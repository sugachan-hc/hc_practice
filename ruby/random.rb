# frozen_string_literal: true

# 通話に参加するメンバー
members = %w[A B C D E F].shuffle
# 最初のグループの人数
group_size = [2, 3].sample

# 最初のグループメンバー
p members.slice(0, group_size).sort
# 残りのグループメンバー
p members.slice(group_size..-1).sort
