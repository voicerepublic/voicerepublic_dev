class Xhr::TagsController < Xhr::BaseController

  def index
    scope = ActsAsTaggableOn::Tag.
            where(["name ILIKE ?", "%#{params[:q]}%"]).
            order('category DESC', :name)

    tags = scope.paginate(:page => params[:page], :per_page => params[:limit] || 10)
    render json: { tags: tags, total: scope.count }
  end

end
