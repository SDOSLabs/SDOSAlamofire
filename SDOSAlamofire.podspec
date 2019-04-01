@version = "0.9.3"
Pod::Spec.new do |spec|
    spec.platform     = :ios, '10.0'
    spec.name         = 'SDOSAlamofire'
    spec.authors      = 'SDOS'
    spec.version      = @version
    spec.license      = { :type => 'SDOS License' }
    spec.homepage     = 'https://svrgitpub.sdos.es/iOS/SDOSAlamofire'
    spec.summary      = 'Librería de integración con Alamofire'
    spec.source       = { :git => "https://svrgitpub.sdos.es/iOS/SDOSAlamofire.git", :tag => "v#{spec.version}" }
    spec.framework    = ['Foundation', 'UIKit']
    spec.requires_arc = true

    spec.subspec 'src' do |s1|
        s1.preserve_paths = 'src/Classes/*'
        s1.source_files = ['src/Classes/*{*.swift}', 'src/Classes/**/*{*.swift}']
    end
    spec.dependency 'Alamofire', '5.0.0-beta.4'
    spec.dependency 'SDOSKeyedCodable', '~> 1.0.0'
    spec.dependency 'SDOSSwiftExtension'
end
