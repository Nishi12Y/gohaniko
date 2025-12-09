class AnswersController < ApplicationController
  before_action :set_group, only: [ :new, :create, :index ]
  PRICE_QUESTION_ID = 8

  def index
    # 各グループで共通の質問を取得
    @questions = Question.where(is_default: true)

    # 質問IDごとに回答一覧を格納するハッシュ
    @answers_by_question = Hash.new { |h, k| h[k] = [] }

    # 3. グループの回答を全て取得(""の回答は除く)
    answers = Answer.where(
      group_id: @group.id,
      question_id: @questions.pluck(:id)
    ).where.not(content: "")

    # 4. 質問IDごとに回答をまとめる
    answers.each do |answer|
      @answers_by_question[answer.question_id] << answer
    end

    # 5. 集計
    @price_counts = Answer.where(group_id: @group.id, question_id: PRICE_QUESTION_ID)
                      .group(:content)
                      .count
  end

  def new
    @question_list = Question.where(is_default: true)

    # 以下回答済み内容の取得
    @answers_by_question = {}

    answer_list = Answer.where(
      question_id: @question_list.pluck(:id),
      user_token: set_user_token,
      group_id: @group.id
    )

    answer_list.each do |answer|
      puts(answer.class)
      puts(answer.inspect)
      @answers_by_question[answer.question_id] = answer
    end
  end

  def create
    # エラー時の再描画用
    @questions = Question.where(is_default: true)
    current_user_token = set_user_token

    @answers = []  # エラー時にビューで使う

    ActiveRecord::Base.transaction do
      answer_params.each do |question_id, content|
        puts ("start create answer")
        answer = Answer.find_or_initialize_by(
          group_id: @group.id,
          question_id: question_id,
          user_token: current_user_token,
        )
        answer.content = content

        @answers << answer

        unless answer.save
          # ここで例外を投げる → transaction が rollback される
          raise ActiveRecord::Rollback
        end
      end
    end

    # 失敗した Answer が含まれていればエラーと判定
    if @answers.any? { |a| a.errors.any? }
      flash.now[:alert] = "入力内容にエラーがあります。確認してください。"
      render :new, status: :unprocessable_entity
    else
      redirect_to group_answers_path(@group), notice: "回答が完了しました！"
    end
  end

  private

  def answer_params
    raw = params.require(:answers).to_unsafe_h

    # ① 数字のキー以外を除外
    filtered = raw.select { |key, _| key.to_s =~ /\A\d+\z/ }

    # ② 値を String のみに制限（Array や Hash を防ぐ）
    filtered.transform_values!(&:to_s)

    filtered
  end

  # ユーザートークンの取得または生成をする関数
  def set_user_token
    if cookies.encrypted[:user_token].present?
      return cookies.encrypted[:user_token]
    end

    token = SecureRandom.uuid
    cookies.encrypted[:user_token] = {
      value: token,
      expires: 1.year.from_now,
      httponly: true, # JavaScriptからのアクセスを防止
      secure: Rails.env.production?, # HTTPS通信時のみ送信
      same_site: :lax # CSRF対策
    }

    token
  end

  def set_group
    @group = Group.find_by(uuid: params[:group_uuid])
    redirect_to root_path, alert: "グループが見つかりませんでした" unless @group
  end
end
