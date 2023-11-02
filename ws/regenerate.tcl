puts "*** Regenerate all BSPs ***"

#Remark: Tested with a single platform only!

#Read all platforms
foreach spr [glob **/*.spr] {
	platform read $spr
}

#Rebuild all platforms/domains
set platforms [dict keys [platform list -dict]]
foreach platform $platforms {
	puts "> Platform: $platform"
	platform generate $platform
	platform active $platform
	set domains [dict keys [domain list -dict]]
	foreach domain $domains {
		puts " > Domain: $domain"
		domain active $domain
		::scw::regenerate_psinit 
		bsp reload
		bsp regenerate
	}
}
