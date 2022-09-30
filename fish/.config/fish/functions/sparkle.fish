function sparkle
	skatecli --skip-ssl log -s $argv > sparklog; and v -i NONE -c '/exception' sparklog
end
