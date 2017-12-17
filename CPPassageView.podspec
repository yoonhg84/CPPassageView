Pod::Spec.new do |s|
  s.name         = "CPPassageView"
  s.version      = "0.1.0"
  s.summary      = "Change value with animation"
  s.description  = <<-DESC
                    Pass view with previous value and show view with current value
                   DESC
  s.homepage     = "https://github.com/yoonhg84/CPPassageView"
  s.license      = "MIT"
  s.author       = { "Chope" => "yoonhg2002@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/yoonhg84/CPPassageView.git", :tag => "#{s.version}" }
  s.source_files = "Sources/*.swift"
end
