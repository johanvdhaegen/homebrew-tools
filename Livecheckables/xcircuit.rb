class Xcircuit
  livecheck :url => "http://opencircuitdesign.com/xcircuit/archive",
            :regex  => %r{href="xcircuit-([0-9.]+)\.tgz"}
end
