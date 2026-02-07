module ApplicationHelper
  def default_meta_tags
    {
      site: "ごはんいこ！",
      title: "ごはんいこ！ - みんなでご飯の予定を簡単に調整",
      reverse: true,
      charset: "utf-8",
      description: "ごはんいこ！では、スケジュールの調整や、みんなでご飯の候補を決めたり、言いにくいことを匿名で共有できたりします。",
      keywords: "ご飯,共有",
      canonical: "https://gohaniko.onrender.com/",
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: "https://gohaniko.onrender.com/",
        image: image_url("gohaniko.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        site: "@obvyamdrss",
        image: image_url("gohaniko.png")
      }
    }
  end
end
