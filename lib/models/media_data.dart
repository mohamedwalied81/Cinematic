import '../models/media_item.dart';

class MediaData {
  static List<MediaItem> movies = [
    MediaItem(
      id: 'm1',
      title: 'The Shawshank Redemption',
      year: '1994',
      genre: 'Drama',
      duration: '2h 22m',
      imdbScore: 9.3,
      type: 'movie',
      imagePath: 'assets/images/shawshank.jpg',
      description:
          'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.',
    ),
    MediaItem(
      id: 'm2',
      title: 'The Godfather',
      year: '1972',
      genre: 'Crime · Drama',
      duration: '2h 55m',
      imdbScore: 9.2,
      type: 'movie',
      imagePath: 'assets/images/godfather.jpg',
      description:
          'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
    ),
    MediaItem(
      id: 'm3',
      title: 'The Dark Knight',
      year: '2008',
      genre: 'Action · Crime',
      duration: '2h 32m',
      imdbScore: 9.0,
      type: 'movie',
      imagePath: 'assets/images/darkknight.jpg',
      description:
          'Batman raises the stakes in his war on crime with the help of Lt. Gordon and DA Harvey Dent, but the Joker emerges to spread chaos.',
    ),
    MediaItem(
      id: 'm4',
      title: 'Schindler\'s List',
      year: '1993',
      genre: 'Biography · Drama',
      duration: '3h 15m',
      imdbScore: 9.0,
      type: 'movie',
      imagePath: 'assets/images/schindler.jpg',
      description:
          'In German-occupied Poland during World War II, Oskar Schindler gradually becomes concerned for his Jewish workforce.',
    ),
    MediaItem(
      id: 'm5',
      title: 'Pulp Fiction',
      year: '1994',
      genre: 'Crime · Drama',
      duration: '2h 34m',
      imdbScore: 8.9,
      type: 'movie',
      imagePath: 'assets/images/pulpfiction.jpg',
      description:
          'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption.',
    ),
    MediaItem(
      id: 'm6',
      title: 'Forrest Gump',
      year: '1994',
      genre: 'Drama · Romance',
      duration: '2h 22m',
      imdbScore: 8.8,
      type: 'movie',
      imagePath: 'assets/images/forrestgump.jpg',
      description:
          'The presidencies of Kennedy and Johnson, the Vietnam War, and other historical events unfold from the perspective of an Alabama man.',
    ),
    MediaItem(
      id: 'm7',
      title: 'Inception',
      year: '2010',
      genre: 'Action · Sci-Fi',
      duration: '2h 28m',
      imdbScore: 8.8,
      type: 'movie',
      imagePath: 'assets/images/inception.jpg',
      description:
          'A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O.',
    ),
    MediaItem(
      id: 'm8',
      title: 'The Matrix',
      year: '1999',
      genre: 'Action · Sci-Fi',
      duration: '2h 16m',
      imdbScore: 8.7,
      type: 'movie',
      imagePath: 'assets/images/matrix.jpg',
      description:
          'A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.',
    ),
    MediaItem(
      id: 'm9',
      title: 'Goodfellas',
      year: '1990',
      genre: 'Biography · Crime',
      duration: '2h 26m',
      imdbScore: 8.7,
      type: 'movie',
      imagePath: 'assets/images/goodfellas.jpg',
      description:
          'The story of Henry Hill and his life in the mob, covering his relationship with his wife Karen and his colleagues in the mob.',
    ),
    MediaItem(
      id: 'm10',
      title: 'Interstellar',
      year: '2014',
      genre: 'Adventure · Drama · Sci-Fi',
      duration: '2h 49m',
      imdbScore: 8.7,
      type: 'movie',
      imagePath: 'assets/images/interstellar.jpg',
      description:
          'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
    ),
  ];

  static List<MediaItem> tvShows = [
    MediaItem(
      id: 't1',
      title: 'Breaking Bad',
      year: '2008',
      genre: 'Crime · Drama · Thriller',
      duration: '5 Seasons',
      imdbScore: 9.5,
      type: 'tvshow',
      imagePath: 'assets/images/breakingbad.jpg',
      description:
          'A chemistry teacher diagnosed with cancer turns to manufacturing drugs to secure his family\'s future.',
    ),
    MediaItem(
      id: 't2',
      title: 'Game of Thrones',
      year: '2011',
      genre: 'Action · Adventure · Drama',
      duration: '8 Seasons',
      imdbScore: 9.2,
      type: 'tvshow',
      imagePath: 'assets/images/got.jpg',
      description:
          'Nine noble families wage war against each other in order to gain control over the mythical land of Westeros.',
    ),
    MediaItem(
      id: 't3',
      title: 'The Wire',
      year: '2002',
      genre: 'Crime · Drama · Thriller',
      duration: '5 Seasons',
      imdbScore: 9.3,
      type: 'tvshow',
      imagePath: 'assets/images/thewire.jpg',
      description:
          'The Baltimore drug scene, as seen through the eyes of drug dealers and law enforcement.',
    ),
    MediaItem(
      id: 't4',
      title: 'Chernobyl',
      year: '2019',
      genre: 'Drama · History · Thriller',
      duration: '1 Season',
      imdbScore: 9.4,
      type: 'tvshow',
      imagePath: 'assets/images/chernobyl.jpg',
      description:
          'In April 1986, an explosion at the Chernobyl nuclear power plant in the USSR becomes one of the world\'s worst nuclear disasters.',
    ),
    MediaItem(
      id: 't5',
      title: 'The Sopranos',
      year: '1999',
      genre: 'Crime · Drama',
      duration: '6 Seasons',
      imdbScore: 9.2,
      type: 'tvshow',
      imagePath: 'assets/images/sopranos.jpg',
      description:
          'New Jersey mob boss Tony Soprano deals with personal and professional issues in his home and business life that affect his mental state.',
    ),
    MediaItem(
      id: 't6',
      title: 'Stranger Things',
      year: '2016',
      genre: 'Drama · Fantasy · Horror',
      duration: '4 Seasons',
      imdbScore: 8.7,
      type: 'tvshow',
      imagePath: 'assets/images/strangerthings.jpg',
      description:
          'When a young boy disappears, his mother and friends must confront terrifying supernatural forces to get him back.',
    ),
    MediaItem(
      id: 't7',
      title: 'Band of Brothers',
      year: '2001',
      genre: 'Action · Drama · History',
      duration: '1 Season',
      imdbScore: 9.4,
      type: 'tvshow',
      imagePath: 'assets/images/bandofbrothers.jpg',
      description:
          'The story of Easy Company of the US Army 506th Parachute Infantry Regiment during World War II.',
    ),
    MediaItem(
      id: 't8',
      title: 'Better Call Saul',
      year: '2015',
      genre: 'Crime · Drama',
      duration: '6 Seasons',
      imdbScore: 9.0,
      type: 'tvshow',
      imagePath: 'assets/images/bettercallsaul.jpg',
      description:
          'The trials and tribulations of criminal lawyer Jimmy McGill in the time before he established his strip-mall law office.',
    ),
    MediaItem(
      id: 't9',
      title: 'The Last of Us',
      year: '2023',
      genre: 'Action · Adventure · Drama',
      duration: '2 Seasons',
      imdbScore: 8.7,
      type: 'tvshow',
      imagePath: 'assets/images/thelastofus.jpg',
      description:
          'After a global catastrophe, a hardened survivor takes charge of a 14-year-old girl who may be humanity\'s last hope.',
    ),
    MediaItem(
      id: 't10',
      title: 'Succession',
      year: '2018',
      genre: 'Drama',
      duration: '4 Seasons',
      imdbScore: 8.9,
      type: 'tvshow',
      imagePath: 'assets/images/succession.jpg',
      description:
          'The Roy family is known for controlling the biggest media and entertainment company in the world. However, their world changes when their father steps down from the company.',
    ),
  ];
}
