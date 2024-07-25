class SearchesController < ApplicationController
  # GET /searches or /searches.json
  def index
    query = params[:query]
    return if query.blank?

    @searches = find_searches(query)
    increment_search_counts(@searches)

    create_search(query) unless search_exists?(query)
  end

  # GET /searches/1 or /searches/1.json
  def show
    @searches = Search.all
  end

  private

  def find_searches(query)
    Search.where('lower(search_params) LIKE ?', "%#{query.downcase}%")
  end

  def increment_search_counts(searches)
    searches.each { |search| search.increment!(:count) }
  end

  def search_exists?(query)
    cleaned_query = split_query(query)

    result = find_filtered_results(cleaned_query.first)

    return false unless result

    update_search_params_if_needed(result, query)

    true
  end

  def split_query(query)
    cleaned_query = query[0...query.rindex(' ')].rstrip

    return [query, query] if query.split.length < 2

    last_query_word = query.split.last

    [cleaned_query, last_query_word]
  end

  def find_filtered_results(cleaned_query)
    Search.find_by('lower(search_params) LIKE ?', "%#{cleaned_query.downcase}%")
  end

  def update_search_params_if_needed(search, query)
    return unless query.rstrip.length > search.search_params.rstrip.length

    search.update(search_params: query, ip_address: search.ip_address)
  end

  def create_search(query)
    Search.create(ip_address: request.remote_ip, search_params: query, count: 1)
  end
end
