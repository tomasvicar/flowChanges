function print_png_eps_svg_fig(name)

    print(name,'-depsc')
    print(name,'-dpng','-r250')
    print(name,'-dsvg')
    savefig([name '.fig'])
end