# --- 共通の質問を作成 ---

Question.find_or_create_by!(
  text: "苦手な食べ物は何ですか？",
  input_type: "text",
  is_default: true
)

q = Question.find_or_create_by!(
  text: "希望する価格帯を選んでください",
  input_type: "select",
  is_default: true
)
q.update!(
  text: "希望する価格帯を選んでください",
  input_type: "select",
  options: [
    {label:"指定なし",value: 9999},
    {label:"〜1000円", value: 1000}, 
    {label:"〜2000円", value: 2000}, 
    {label:"〜3000円", value: 3000}, 
    {label:"~4000円", value: 4000}, 
    {label:"~5000円", value: 5000}, 
    {label:"~6000円", value: 6000}, 
    {label:"~7000円", value: 7000}, 
    {label:"~8000円", value: 8000}, 
    {label:"〜9000円", value: 9000}
  ],
  is_default: true
)

Question.find_or_create_by!(
  text: "集合時間を選んでください",
  input_type: "time",
  is_default: true
)

