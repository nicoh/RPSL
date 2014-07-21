#!/usr/bin/ruby

require 'rgen/instantiator/ecore_xml_instantiator'
require 'mmgen/metamodel_generator'

include MMGen::MetamodelGenerator

def check_args(argv)
        infile = argv[0]
        outfile = argv[1]

        def usage()
                puts __FILE__ + " <ecore> <outfile>"
        end

        if argv.length < 1 then
                usage()
                exit(1)
        end

        if not ( FileTest.file?(infile) and
                 FileTest.readable?(infile) ) then
                puts("ERR: argument '" + infile + "' not a file or unreadable")
                exit(1)
        end

        if not outfile then
                outfile = File.basename(infile, ".ecore") + "-regen.rb"
        end

        return infile, outfile
end

infile, outfile = check_args(ARGV)

# here we go
env = RGen::Environment.new
File.open(infile) { |f|
        puts "instantiating " + infile + " ..."
        ECoreXMLInstantiator.new(env).instantiate(f.read)
}

rootPackage = env.find(:class => RGen::ECore::EPackage).first

puts "generating " + outfile + " ..."
generateMetamodel(rootPackage, outfile)
