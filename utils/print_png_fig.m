function print_png_fig(name)

    print(name,'-dpng','-r250')
    savefig([name '.fig'])
end