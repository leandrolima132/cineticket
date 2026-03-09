import 'package:cineticket/modules/movies/domain/entities/movie.dart';

class MovieMock {
  static Movie get movie1 => const Movie(
        id: '1',
        title: 'The Matrix',
        description:
            'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.',
        posterUrl:
            'https://cdn.displate.com/artwork/270x380/2023-06-06/f93133bd386b38214825278cc5f543bd_acb4bcaee53ac98ed81cf36c5c5b810c.jpg',
        duration: '136 min',
        genres: 'Action, Sci-Fi',
        rating: '8.7',
        releaseDate: '1999-03-31',
      );

  static Movie get movie2 => const Movie(
        id: '2',
        title: 'Inception',
        description:
            'A skilled thief is given a chance at redemption if he can pull off an impossible heist: inception, the planting of an idea in a target\'s mind.',
        posterUrl:
            'https://image.tmdb.org/t/p/original/xlaY2zyzMfkhk0HSC5VUwzoZPU1.jpg',
        duration: '148 min',
        genres: 'Action, Sci-Fi, Thriller',
        rating: '8.8',
        releaseDate: '2010-07-16',
      );

  static Movie get movie3 => const Movie(
        id: '3',
        title: 'Interstellar',
        description:
            'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
        posterUrl:
            'https://cdn.myportfolio.com/21f06b7e8ef08857ad7f8fa89c6f29ed/fdb781c8-4ee8-4c52-871f-fe5532482265_rw_1200.png?h=25cc36ad9d5537d6922988b5cfd68441',
        duration: '169 min',
        genres: 'Adventure, Drama, Sci-Fi',
        rating: '8.6',
        releaseDate: '2014-11-07',
        highlight: true,
      );

  static List<Movie> get moviesList => [movie1, movie2, movie3];
}
