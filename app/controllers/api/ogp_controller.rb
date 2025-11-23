class Api::OgpController < ApplicationController
  def show
    url = params[:url]
    return render json: { error: "URL is required" }, status: :bad_request if url.blank?

    begin
      page = MetaInspector.new(
        url,
        allow_non_html_content: false,
        headers: {
          "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
        },
        faraday_options: {
          ssl: { verify: false },
          request: { timeout: 10 }
        }
      )

      render json: {
        title:       page.best_title,
        description: page.best_description,
        image:       page.images.best,
        url:         page.url
      }

    rescue => e
      Rails.logger.error("[OGP ERROR] #{e.class}: #{e.message}")
      render json: { error: "Failed to fetch OGP" }, status: :unprocessable_content
    end
  end
end
