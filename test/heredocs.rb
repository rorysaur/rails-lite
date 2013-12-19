def heredocs

  html = <<-HTML
  <form action="some_url" method="post">
    <input type="submit" value="button_name">
  </form>
  HTML
  
  puts html
end

heredocs