Pod::Spec.new do |s|
  s.name                  = 'ZoomTransitioning'
  s.version               = '1.4.1'
  s.summary               = 'ZoomTransitioning provides a custom transition with image zooming animation.'
  s.description           = <<-DESC
                            ZoomTransitioning provides a custom transition with image zooming animation.
                            When you use this library with UINavigationController, you can pop view controller with edge swiping.
                            DESC
  s.homepage              = 'https://github.com/WorldDownTown/ZoomTransitioning'
  s.screenshots           = 'http://i.giphy.com/l0HlGSD26DXKSqWBi.gif'
  s.license               = { type: 'MIT', file: 'LICENSE' }
  s.author                = { 'WorldDownTown' => 'WorldDownTown@gmail.com' }
  s.source                = { git: 'https://github.com/WorldDownTown/ZoomTransitioning.git', tag: s.version.to_s }
  s.social_media_url      = 'https://twitter.com/WorldDownTown'
  s.ios.deployment_target = '8.0'
  s.source_files          = 'ZoomTransitioning/*.swift'
  s.frameworks            = 'UIKit'
end
