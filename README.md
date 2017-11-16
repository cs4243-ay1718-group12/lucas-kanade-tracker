# lucas-kanade-tracker
The pyramidal Lucas-Kanade tracking algorithim implemented in `matlab`.

For NUS module CS4232 by: Darren, Le Minh Duc, Regine, Rohit

## How to Use
1. Open `main.m` in Matlab.
2. Modify parameters as necessary:
    - `IO_FILENAME` the path to the target video file
    - `CORNER_NUM` number of corners to look for in the area of interest (impacts performance)
    - `CORNER_FILTER_SIZE` size of the Gaussian window in corner discovery
    - `LK_WIN_RADIUS`
    - `LK_ACCURACY`
    - `LK_MAX_ITER`
    - `PLOT_INITIAL` set to `true` to plot the initial corners over the image
3. Run `main.m`.
4. When an image of the video pops up, you must use your cursor to drag a bounding area for discovering features of interest.
5. The video with tracked corners will play when the program has finished computing. This may take a while depending on the size of the video and number of corners discovered.
