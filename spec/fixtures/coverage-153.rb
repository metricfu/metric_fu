# from https://github.com/metricfu/metric_fu/issues/153
class A
  def m(arg1)
    p "this is my method" # Assume that none of the line covered in this method
    if arg1 > 5
      p "more than 5"
    else
      p "not more than 5"
    end
  end
end
