@version = "0.10.0"
Pod::Spec.new do |spec|
    spec.platform     = :ios, '10.0'
    spec.name         = 'SDOSAlamofire'
    spec.authors      = 'SDOS'
    spec.version      = @version
    spec.license      = { :type => 'MIT' }
    spec.homepage     = 'https://github.com/SDOSLabs/SDOSAlamofire'
    spec.summary      = 'Librería de integración con Alamofire'
    spec.source       = { :git => "https://github.com/SDOSLabs/SDOSAlamofire.git", :tag => "v#{spec.version}" }
    spec.framework    = ['Foundation']
    spec.requires_arc = true

    spec.default_subspec = 'Core'

    spec.subspec 'Core' do |s1|
        s1.preserve_paths = 'src/Classes/Core/*'
        s1.source_files = ['src/Classes/Core/*{*.swift}', 'src/Classes/Core/**/*{*.swift}']
    end

    spec.subspec 'JSONAPI' do |s1|
        s1.preserve_paths = 'src/Classes/JSONAPI/*'
        s1.source_files = ['src/Classes/JSONAPI/*{*.swift}', 'src/Classes/JSONAPI/**/*{*.swift}']
        s1.dependency 'SDOSAlamofire/Core'
        s1.dependency 'Japx/Codable'
    end

    spec.dependency 'Alamofire', '5.0.0-rc.2'
    spec.dependency 'SDOSKeyedCodable', '~> 1.0.0'
    spec.dependency 'SDOSSwiftExtension'
end
