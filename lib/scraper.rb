class Scraper

  def self.scrape_index_page(index_url)

    # sends a request to url (open url)
    # nokogirl parses HTML (so after we can use .css)
    doc = Nokogiri::HTML(open(index_url))
    
    # array that will hold student hash data
    student_array = []
    
    # goes though tags and pulls student_info
    doc.css('.student-card').each do |student_card|
      hash = {
        profile_url: student_card.css('a').attr('href').value, 
        name: student_card.css('h4.student-name').text,
        location: student_card.css('p.student-location').text
      }

      # shovels student student_info from hash to array
      student_array << hash
    end
    # returns array with student student_info in hash
    student_array
  end

  def self.scrape_profile_page(profile_url)
    # scrape each student profile page to get student_info about student
    
    doc = Nokogiri::HTML(open(profile_url))

    students_profile = doc.css("div.main-wrapper.profile")
    student_info = {}

    students_profile.each do |student|
      student_info = {
        :profile_quote => student.css(" div.profile-quote").text,
        :bio => student.css(" div.description-holder p").text
      }
      links = student.css(" div.social-icon-container a")
      links.each do |link|
        url = link.attr('href')
        if url.include?("twitter")
          student_info[:twitter] = url
        elsif url.include?("linkedin")
          student_info[:linkedin] = url
        elsif url.include?("github")
          student_info[:github] = url
        else
          student_info[:blog] = url
        end
      end
    end
    student_info
  end
  
end

