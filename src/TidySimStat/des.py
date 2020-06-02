class Node:

    def __init__(self, index):
        self._index = index
        self._next = None


class Head:

    def __init__(self):
        "Initiate an empty linked list."
        self._next = None

    def insert(self, node_new):
        "Insert the given node according to indices."
        cur = self._next
        while True:
            if cur._next is None:
                cur._next = node_new
                break
            elif cur._next._index < node_new._index:
                cur = cur._next
            else:
                node_new._next = cur._next
                cur._next = node_new
                break

    def print_all(self):
        cur = self._next
        i = 1
        while cur:
            print(f"{i}-th event invoke time: {cur._index}")
            cur = cur._next
            i += 1


class Event(Node):

    def __init__(self, time, whi_server=None):
        super().__init__(time)
        self.whi_server = whi_server

    def trigger(self):
        "The event is triggered."


class Servers(Head):

    def __init__(self, num, f_serve, f_arrive):
        if not callable(f_serve):
            raise ValueError("Function to simulate service time is "
                "not callable.")
        if not callable(f_arrive):
            raise ValueError("Function to simulate arrival sojourn time is "
                "not callable.")

        super().__init__()
        self.states = [0 for i in range(num)]
        self.num_arrival = 0
        self.blocks = {}
        self.f_serve = f_serve
        self.f_arrive = f_arrive
        self.clock = 0
        self._last_schedule = 0

    def warmup(self):
        self.states[0] = 1

        self._last_schedule += self.f_arrive()
        self._next = Event(self._last_schedule)

        for i in range(10):
            self.schedule()

    def schedule(self):
        """The new arrival always follows the last scheduled arrival."""
        self._last_schedule += self.f_arrive()
        self.insert(Event(self._last_schedule))

    def arrive(self):
        "Event routine triggered when a new customer arrives."
        self.num_arrival += 1
        first = self.first_idle + 0
        if first > self.num:  # There is no idle server.
            ## The customer is blocked.
            ## There is no need to set a `leave` event.
            self.blocks[len(self.blocks) + 1] = self.num_arrival
        else:
            ## To assign the customer to the first idle server and simulate
            ## his/her leaving time.
            self.states[first] = 1
            print(self.states)  # !!!!!!!!!!!!!!!!!!!!!!!!!!!
            t_leave = self.clock + self.f_serve()
            self.insert(Event(t_leave, first))

        ## Next schedule
        self.schedule()

    def leave(self, whi_server):
        "Event routine triggered when an existing customer leaves."
        self.states[whi_server] = 0

    def advance(self):
        "Invoke next event and advance the clock time."
        self.clock = self._next._index + 0
        # print(self.clock)
        if self._next.whi_server:
            self.leave(self._next.whi_server)
        else:
            self.arrive()

        self._next = self._next._next
        return self.clock

    @property
    def num(self):
        return len(self.states)

    @property
    def first_idle(self):
        result = 0
        i = 0
        while i <= self.num:
            if self.states[i] == 0:
                break
            else:
                i += 1
        return i
