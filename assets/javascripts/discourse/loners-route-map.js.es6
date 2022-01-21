export default function () {
  this.route("loners", function () {
    this.route("watch", { path: "/loners/watch" });
  });
}