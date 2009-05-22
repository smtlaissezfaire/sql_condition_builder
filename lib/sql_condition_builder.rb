class SqlConditionBuilder
  def initialize
    @strings = []
    @bind_variables = []
    @sql_array = [@strings, @bind_variables]
  end

  class EmptyCondition; end

  def add_condition(string, bind_variable=EmptyCondition.new)
    @strings << string
    
    unless bind_variable.kind_of?(EmptyCondition)
      @bind_variables << bind_variable
    end
  end
  
  def to_a
    [@strings.join(" AND "), @bind_variables].flatten
  end

  def to_s
    sanitize_sql to_a
  end

  alias_method :to_sql, :to_s

  def respond_to?(sym, include_private=false)
    accessor?(sym) || super
  end

private

  def method_missing(sym, *args, &block)
    if accessor?(sym)
      add_condition("#{sym.to_s.gsub("=", " =")} ?", args.first)
    else
      super
    end
  end

  def accessor?(sym)
    sym.to_s =~ /.*\=$/ ? true : false
  end

  def sanitize_sql(array)
    ActiveRecord::Base.send :sanitize_sql, array
  end
end
