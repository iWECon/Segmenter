Pod::Spec.new do |s|

    s.name = 'Segmenter'
    s.version = '2.1.2'
    s.license = { :type => 'MIT' }
    s.homepage = 'https://github.com/iWECon/Segmenter'
    s.authors = 'iWw'
    s.ios.deployment_target = '10.0'
    s.summary = 'Segmenter'
    s.source = { :git => 'https://github.com/iWECon/Segmenter.git', :tag => s.version }
    s.source_files = [
        'Sources/**/*.swift',
    ]
    
    s.cocoapods_version = '>= 1.10.0'
    s.swift_version = ['5.3']
    
end


