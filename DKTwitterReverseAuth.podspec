
Pod::Spec.new do |s|

  s.name         = "DKTwitterReverseAuth"
  s.version      = "0.1"
  s.summary      = "Simple Twitter Reverse Auth"

  s.homepage     = "https://github.com/dkhamsing/DKTwitterReverseAuth"

  s.license      = { :type => "MIT", :file => "LICENSE" }
 
  s.author             = { "dkhamsing" => "dkhamsing8@gmail.com" }
  s.social_media_url   = "http://twitter.com/dkhamsing" 

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/dkhamsing/DKTwitterReverseAuth.git", :tag => s.version.to_s }
 
  s.source_files  = "DKTwitterReverseAuth/*"
   
  s.requires_arc = true
  
  s.dependency 'OAuthCore'

end
