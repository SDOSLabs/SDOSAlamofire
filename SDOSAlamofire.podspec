@version = "0.1.0"
Pod::Spec.new do |spec|
    spec.platform     = :ios, '10.0'
    spec.name         = 'SDOSAlamofire'
    spec.authors      = 'SDOS'
    spec.version      = @version
    spec.license      = { :type => 'SDOS License' }
    spec.homepage     = 'https://svrgitpub.sdos.es/antonioj.pallares/SDOSAlamofire'
    spec.summary      = 'Librería de integración con Alamofire'
    spec.source       = { :git => "https://svrgitpub.sdos.es/antonioj.pallares/SDOSAlamofire", :tag => "v#{spec.version}" }
    spec.framework    = ['Foundation', 'UIKit']
    spec.requires_arc = true

    spec.subspec 'src' do |s1|
        s1.preserve_paths = 'src/Classes/*'
        s1.source_files = ['src/Classes/*{*.m,*.h,*.swift}', 'src/Classes/**/*{*.m,*.h,*.swift}']
    end
    spec.dependency 'Alamofire', '5.0.0-beta.1'
    spec.dependency 'KeyedCodable'
end
