library(ggplot2)

p <- ggplot(mtcars, aes(x = mpg, y = hp, col = cyl)) +         # Defining data and aesthetic mapping
  geom_point(size = 2) +                                  # Defining geometric object
  xlab("Miles per gallon") + ylab("Horsepower") + # Guides: labeling axes
  xlim(0, 40) + ylim(0, 350) +                      # Scales: setting x and y limits
  labs(color = "Cylinders")  + 
  theme_bw()

pdf(file = "pdfexample.pdf", width = 6, height = 5)
p
dev.off()

setEPS()
postscript(file = "epsexample.eps")
p
dev.off()

png(filename = "pngexample.png", width = 6, height = 5, units = "in", res = 600)
p
dev.off()

tiff(filename = "tiffexample.tiff", width = 6, height = 5, units = "in", res = 600, 
     compression = "none")
p
dev.off()

p
ggsave(filename = "ggsave.pdf", plot = last_plot(), device = "pdf", 
       width = 6, height = 5, units = "in")