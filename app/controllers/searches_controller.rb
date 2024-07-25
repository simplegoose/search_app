class SearchesController < ApplicationController
  # GET /searches or /searches.json
  def index
    query = params[:query]
    
    if query.empty?
      return
    end

    exists = check_existing

    print 'it exists ', exists
    
    @searches = Search.where("lower(search_params) Like ?", "%#{query.downcase}%");

    for search in @searches
      search.count = search.count + 1
      search.save
    end

    if !exists
      Search.create(ip_address: request.remote_ip, search_params: params[:query], count: 1);
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
    last_query_word = query.split(' ').last

    result = Search.where("lower(search_params) Like ?", "%#{cleaned_query.strip.downcase}%")
    first_of_result = result.find { |obj| obj.search_params.include? last_query_word }

    if !first_of_result
      return false
    end

    if first_of_result && query.lstrip.length > first_of_result.search_params.length && first_of_result.ip_address == request.remote_ip
      first_of_result.search_params = query
      first_of_result.save

      return result.length > 0
    end

    return first_of_result
  end

end
