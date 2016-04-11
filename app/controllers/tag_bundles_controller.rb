class TagBundlesController < ApplicationController
  def show
    respond_to do |format|
      format.rss do
        @tag_bundle = TagBundle.find(params[:id])
        talks = Talk.archived.ordered.limit(20).
                tagged_with(@tag_bundle.tag_list, any: true)
        @podcast = OpenStruct.new(talks: talks)
      end
    end
  end
end
