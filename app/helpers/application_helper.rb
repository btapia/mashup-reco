module ApplicationHelper
  def add_param(params, key, value)
    params.merge(key => value) { |k,o,n| k == key ? (o.split(',') | [n.to_s]).join(',') : o }
  end

  def remove_param(params, key, value)
    params.merge(key => value) { |k,o,n| k == key ? (o.split(',') - [n.to_s]).join(',') : o }
  end
end
