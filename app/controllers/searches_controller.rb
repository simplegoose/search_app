class SearchesController < ApplicationController
  # GET /searches or /searches.json
  def index
    query = params[:query]

    return unless query

    exists = check_existing

    @searches = Search.where('lower(search_params) Like ?', "%#{query.downcase}%")

    @searches.each do |search|
      search.count = search.count + 1
      search.save
    end

    return if exists

    print 'after existss'

    Search.create(ip_address: request.remote_ip, search_params: params[:query], count: 1)
  end

  # GET /searches/1 or /searches/1.json
  def show
    @searches = Search.all
  end

  private

  def check_existing
    query = params[:query]
    cleaned_query = query[0...query.rindex(' ')].rstrip
    last_query_word = query.split.last

    result = Search.where('lower(search_params) Like ?', "%#{cleaned_query.downcase}%")
    first_of_result = result.find { |obj| (last_query_word.include? obj.search_params.split.last) || (obj.search_params.last.include? last_query_word) }
    print first_of_result

    return false unless first_of_result

    if first_of_result &&
       query.rstrip.length > first_of_result.search_params.length &&
       first_of_result.ip_address == request.remote_ip
      first_of_result.search_params = query
      first_of_result.save

      return result.length.positive?
    end

    first_of_result
  end
end
