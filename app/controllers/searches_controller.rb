class SearchesController < ApplicationController
  # GET /searches or /searches.json
  def index
    query = params[:query]
    
    if query.empty?
      return
    end

    exists = check_existing
    
    @searches = Search.where("lower(search_params) Like ?", "%#{query.downcase}%");

    if exists
      return
    end

    unless @searches.length > 0 && query
      Search.create(ip_address: request.remote_ip, search_params: params[:query], count: 1);
    end

    for search in @searches
      search.count = search.count + 1
      search.save
    end
    
  end

  # GET /searches/1 or /searches/1.json
  def show
    @searches = Search.all
  end

  private

  def check_existing
    query = params[:query]
    cleaned_query = query[0...query.rindex(' ')]

    result = Search.where("lower(search_params) Like ?", "%#{cleaned_query.downcase}%")
    first = result[0]

    if result.length == 1 && first.search_params.length < query.length
      result[0].search_params = query
      result[0].save
    end

    result.length > 0
  end

end
