# Font-Shaker
Shake your font !


### Usage

For exemple to generate shaked font named Demo and osa permutation script whith seed 8945 :

```
docker run -v $(pwd)/input.ttf:/input.ttf\
			 -v $(pwd)/output:/output\
			 -it hackdaddy/font-shaker\
			 --preserve-space\
			 --font-name=Demo\
			 --generate-osascript\
			 --seed=8945
```

To shake a text with the same seed :

```
docker run -it hackdaddy/font-shaker\
			 --preserve-space\
			 --seed=8945\
			 --text='Hello world !!!'
```